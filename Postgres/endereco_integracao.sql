-- Table: public.endereco_integracao

-- DROP TABLE public.endereco_integracao;

CREATE TABLE public.endereco_integracao
(
    idendereco bigint NOT NULL,
    ds_uf bit varying(50),
    nmcidade bit varying(100),
    nmbairro bit varying(50),
    nmlogradouro bit varying(100),
    dscomplemento bit varying(100),
    CONSTRAINT endereco_integracao_pkey PRIMARY KEY (idendereco),
    CONSTRAINT enderecointegracao_fk_endereco FOREIGN KEY (idendereco)
        REFERENCES public.endereco (idendereco) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.endereco_integracao
    OWNER to postgres;