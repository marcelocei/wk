-- Table: public.endereco

-- DROP TABLE public.endereco;

CREATE TABLE public.endereco
(
    idendereco bigint NOT NULL,
    idpessoa bigint NOT NULL,
    dscep character varying(15) COLLATE pg_catalog."default",
    CONSTRAINT endereco_pkey PRIMARY KEY (idendereco),
    CONSTRAINT endereco_fk_pessoa FOREIGN KEY (idpessoa)
        REFERENCES public.pessoa (idpessoa) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.endereco
    OWNER to postgres;
-- Index: endereco_idpessoa

-- DROP INDEX public.endereco_idpessoa;

CREATE INDEX endereco_idpessoa
    ON public.endereco USING btree
    (idpessoa ASC NULLS LAST)
    TABLESPACE pg_default;