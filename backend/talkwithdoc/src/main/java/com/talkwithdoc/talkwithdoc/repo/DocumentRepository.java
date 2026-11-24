package com.talkwithdoc.talkwithdoc.repo;

import com.talkwithdoc.talkwithdoc.entity.Document;
import com.talkwithdoc.talkwithdoc.entity.DocumentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface DocumentRepository extends JpaRepository<Document, UUID> {

    List<Document> findAllByUserIdOrderByCreatedAtDesc(UUID userId);

    Optional<Document> findByIdAndUserId(UUID id, UUID userId);

    Optional<Document> findByUserIdAndContentHash(UUID userId, String contentHash);

    // Bulk update avoids loading the entity, but @UpdateTimestamp does not fire
    // for JPQL updates, so updatedAt is set explicitly.
    @Modifying
    @Query("""
        update Document d
           set d.status = :status,
               d.errorMessage = :error,
               d.updatedAt = CURRENT_TIMESTAMP
         where d.id = :id
        """)
    int updateStatus(@Param("id") UUID id,
                     @Param("status") DocumentStatus status,
                     @Param("error") String error);
}
