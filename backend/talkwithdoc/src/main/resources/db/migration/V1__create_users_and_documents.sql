CREATE TABLE users (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username   VARCHAR(50)  NOT NULL,
    email      VARCHAR(100) NOT NULL,
    password   VARCHAR(255) NOT NULL,
    role       VARCHAR(20)  NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP    NOT NULL DEFAULT now(),

    CONSTRAINT uk_users_email UNIQUE (email)
);

CREATE TABLE documents (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    filename         VARCHAR(255) NOT NULL,
    file_type        VARCHAR(20)  NOT NULL,
    file_size_bytes  BIGINT       NOT NULL,
    storage_path     VARCHAR(500) NOT NULL,
    content_hash     VARCHAR(64)  NOT NULL,
    page_count       INT,
    total_chunks     INT          NOT NULL DEFAULT 0,
    status           VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
    error_message    VARCHAR(1000),
    parser_version   VARCHAR(50),
    embedding_model  VARCHAR(100),
    created_at       TIMESTAMP    NOT NULL DEFAULT now(),
    updated_at       TIMESTAMP    NOT NULL DEFAULT now(),

    CONSTRAINT uk_documents_user_hash UNIQUE (user_id, content_hash)
);

CREATE INDEX idx_documents_user_id     ON documents (user_id);
CREATE INDEX idx_documents_user_status ON documents (user_id, status);