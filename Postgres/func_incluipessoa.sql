-- FUNCTION: public.incluipessoa(integer, text, text, text, text)

-- DROP FUNCTION public.incluipessoa(integer, text, text, text, text);

CREATE OR REPLACE FUNCTION public.incluipessoa(
	flnatureza integer,
	dsdocumento text,
	nmprimeiro text,
	nmsegundo text,
	dscep text)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    IDPESSOA BIGINT;
	IDENDERECO BIGINT;
BEGIN
  IDPESSOA = ID_PESSOA();
  IDENDERECO = ID_ENDERECO();
  
  INSERT INTO PESSOA (IDPESSOA, FLNATUREZA, DSDOCUMENTO, NMPRIMEIRO, NMSEGUNDO, DTREGISTRO)
  VALUES(IDPESSOA,FLNATUREZA,DSDOCUMENTO,NMPRIMEIRO,NMSEGUNDO,CURRENT_DATE);

  INSERT INTO ENDERECO (IDENDERECO, IDPESSOA, DSCEP) 
  VALUES (IDENDERECO, IDPESSOA, DSCEP);

RETURN TRUE;
END;
$BODY$;

ALTER FUNCTION public.incluipessoa(integer, text, text, text, text)
    OWNER TO postgres;
