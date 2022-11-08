-- Table: public.pessoa

-- DROP TABLE public.pessoa;

CREATE TABLE public.pessoa
(
    idpessoa bigint NOT NULL DEFAULT nextval('pessoa_idpessoa_seq'::regclass),
    flnatureza smallint NOT NULL,
    dsdocumento character varying(20) COLLATE pg_catalog."default" NOT NULL,
    nmprimeiro character varying(100) COLLATE pg_catalog."default" NOT NULL,
    nmsegundo character varying(100) COLLATE pg_catalog."default" NOT NULL,
    dtregistro date,
    CONSTRAINT pessoa_pkey PRIMARY KEY (idpessoa)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.pessoa
    OWNER to postgres;