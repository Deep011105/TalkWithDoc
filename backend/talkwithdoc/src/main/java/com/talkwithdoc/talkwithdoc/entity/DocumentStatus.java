package com.talkwithdoc.talkwithdoc.entity;

public enum DocumentStatus {
    PENDING,      // uploaded, queued
    PROCESSING,   // parsing / chunking / embedding in progress
    READY,        // searchable
    FAILED        // see errorMessage
}