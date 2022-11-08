-- FUNCTION: public.id_endereco()

-- DROP FUNCTION public.id_endereco();

CREATE OR REPLACE FUNCTION public.id_endereco(
	)
    RETURNS bigint
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    SEQ BIGINT;
BEGIN
  SELECT MAX(IDENDERECO) +1 INTO SEQ FROM ENDERECO;
  
  IF SEQ IS NULL THEN
    SEQ := 1;
  END IF;

  RETURN SEQ;
END;
$BODY$;

ALTER FUNCTION public.id_endereco()
    OWNER TO postgres;
