--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4 (Ubuntu 15.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 15.4 (Ubuntu 15.4-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: fidlar; Type: TABLE; Schema: public; Owner: madsugod
--

CREATE TABLE public.fidlar (
    name character varying(20) NOT NULL,
    role character varying(15),
    age integer
);


ALTER TABLE public.fidlar OWNER TO madsugod;

--
-- Data for Name: fidlar; Type: TABLE DATA; Schema: public; Owner: madsugod
--

COPY public.fidlar (name, role, age) FROM stdin;
max	drums	28
brandon	guitar	28
elvis	gone	26
zac	vocals	31
alice	\N	25
sound engineer guy	\N	30
sds	jsds	30
shopkeeper	tacos	50
sdjkdstest	iiii	39
test	test2	20
\.


--
-- Name: fidlar fidlar_pkey; Type: CONSTRAINT; Schema: public; Owner: madsugod
--

ALTER TABLE ONLY public.fidlar
    ADD CONSTRAINT fidlar_pkey PRIMARY KEY (name);


--
-- Name: fidinex; Type: INDEX; Schema: public; Owner: madsugod
--

CREATE INDEX fidinex ON public.fidlar USING btree (age);


--
-- Name: fidlar_name_role_idx; Type: INDEX; Schema: public; Owner: madsugod
--

CREATE UNIQUE INDEX fidlar_name_role_idx ON public.fidlar USING btree (name) INCLUDE (role);


--
-- Name: TABLE fidlar; Type: ACL; Schema: public; Owner: madsugod
--

GRANT ALL ON TABLE public.fidlar TO lidy;


--
-- PostgreSQL database dump complete
--

