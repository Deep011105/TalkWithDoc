package com.talkwithdoc.talkwithdoc.repo;

import com.talkwithdoc.talkwithdoc.entity.DocumentChunk;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.UUID;

public interface DocumentChunkRepository extends JpaRepository<DocumentChunk, UUID> {

    long countByDocumentId(UUID documentId);

    @Modifying
    @Query("delete from DocumentChunk c where c.document.id = :documentId")
    void deleteByDocumentId(@Param("documentId") UUID documentId);

    // Vector and hybrid search queries are added with the retrieval step (native SQL).
}
