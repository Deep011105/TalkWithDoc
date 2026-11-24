CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE document_chunks (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id    UUID        NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    user_id        UUID        NOT NULL REFERENCES users(id)     ON DELETE CASCADE,
    parent_id      UUID        REFERENCES document_chunks(id)    ON DELETE CASCADE,

    chunk_index    INT         NOT NULL,
    chunk_type     VARCHAR(20) NOT NULL DEFAULT 'TEXT',   -- TEXT | TABLE | CODE
    content        TEXT        NOT NULL,                  -- raw chunk text shown to the LLM
    context_prefix TEXT,                                  -- optional "where this chunk sits" blurb
    section_path   TEXT,                                  -- "Contract > Payment Terms > Late Fees"
    page_start     INT,
    page_end       INT,
    token_count    INT,

    embedding      vector(768) NOT NULL,                  -- must match your embedding model

    search_vector  tsvector GENERATED ALWAYS AS (
        to_tsvector('english', coalesce(section_path, '') || ' ' || content)
    ) STORED,

    created_at     TIMESTAMP   NOT NULL DEFAULT now(),

    CONSTRAINT uk_chunk_doc_index UNIQUE (document_id, chunk_index)
);

CREATE INDEX idx_chunks_user_id     ON document_chunks (user_id);
CREATE INDEX idx_chunks_document_id ON document_chunks (document_id);
CREATE INDEX idx_chunks_parent_id   ON document_chunks (parent_id);

CREATE INDEX idx_chunks_embedding_hnsw
    ON document_chunks USING hnsw (embedding vector_cosine_ops)
    WITH (m = 16, ef_construction = 64);

CREATE INDEX idx_chunks_search_vector
    ON document_chunks USING gin (search_vector);