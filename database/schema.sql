-- Clinical Variant Explorer
-- PostgreSQL schema for storing VEP-annotated human genetic variants.

CREATE TABLE variants (
    id BIGSERIAL PRIMARY KEY,
    chromosome VARCHAR(10) NOT NULL,
    position BIGINT NOT NULL,
    reference_allele TEXT NOT NULL,
    alternate_allele TEXT NOT NULL,
    gene_symbol VARCHAR(50),
    variant_identifier VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT unique_variant
        UNIQUE (chromosome, position, reference_allele, alternate_allele)
);

CREATE TABLE consequences (
    id BIGSERIAL PRIMARY KEY,
    variant_id BIGINT NOT NULL,
    transcript_id VARCHAR(100),
    consequence_type TEXT NOT NULL,
    impact VARCHAR(20),
    biotype VARCHAR(100),

    CONSTRAINT fk_consequence_variant
        FOREIGN KEY (variant_id)
        REFERENCES variants(id)
        ON DELETE CASCADE
);

CREATE TABLE frequencies (
    id BIGSERIAL PRIMARY KEY,
    variant_id BIGINT NOT NULL,
    population VARCHAR(100) NOT NULL,
    allele_frequency DOUBLE PRECISION,

    CONSTRAINT fk_frequency_variant
        FOREIGN KEY (variant_id)
        REFERENCES variants(id)
        ON DELETE CASCADE
);

CREATE TABLE phenotypes (
    id BIGSERIAL PRIMARY KEY,
    variant_id BIGINT NOT NULL,
    hpo_id VARCHAR(20),
    hpo_label TEXT,

    CONSTRAINT fk_phenotype_variant
        FOREIGN KEY (variant_id)
        REFERENCES variants(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_variants_gene_symbol
    ON variants(gene_symbol);

CREATE INDEX idx_variants_genomic_position
    ON variants(chromosome, position);

CREATE INDEX idx_consequences_variant_id
    ON consequences(variant_id);

CREATE INDEX idx_frequencies_variant_id
    ON frequencies(variant_id);

CREATE INDEX idx_phenotypes_variant_id
    ON phenotypes(variant_id);