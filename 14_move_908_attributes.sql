INSERT INTO public.attriblist(
	pk, type, name, caption)
	VALUES (908, 'unc', '908 - Reading Level', 'Reading Level');

CREATE OR REPLACE FUNCTION public._attributes_tsvec(r public.attributes) RETURNS tsvector
    LANGUAGE plpgsql
    AS $$
	-- creates tsvector from attributes record
BEGIN
	IF r.fk_attriblist IN (240, 245, 246, 440, 500, 505) THEN
	        -- titles
		RETURN setweight (px ('t', r.text), 'B');
 	ELSIF r.fk_attriblist NOT IN (508, 520, 540, 901, 902, 903, 904, 905, 908) THEN		      
		-- other attributes we want to search
		RETURN to_tsvector ('pg_catalog.english', r.text);
	END IF;

	RETURN NULL;
END;
$$;


CREATE OR REPLACE FUNCTION public._attributes_tsvec_update(r public.attributes) RETURNS tsvector
    LANGUAGE plpgsql
    AS $$
-- creates tsvector from attributes record
DECLARE
tsv TSVECTOR := NULL;
BEGIN
IF r.fk_attriblist IN (240, 245, 246, 440, 500, 505) THEN
        -- title
tsv := setweight (to_tsvector (
             'pg_catalog.english', pf2 ('tx', r.text)), 'B');
 ELSIF r.fk_attriblist NOT IN (508, 520, 540, 901, 902, 903, 904, 905, 908) THEN      
-- other attributes we want to search
tsv := setweight (to_tsvector ('pg_catalog.english', r.text), 'C');
END IF;

RETURN tsv;
END;
$$;

-- apply the revised function to the attributes table
UPDATE public.attributes SET fk_attriblist='908' WHERE text like 'Reading ease score:%';
UPDATE public.attributes SET text=text WHERE fk_attriblist='500';
