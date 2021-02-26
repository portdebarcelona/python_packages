ALTER SESSION SET CURRENT_SCHEMA=GIS;

CREATE TABLE "EDIFICACIO"
 ("APB_ID" number(11) not null,
"TIPUS_EDIFICACIO" varchar2(35) not null,
"US_EDIFICACIO" varchar2(30),
"NUMERO_PLANTES" number(11),
"LIT_DENOMINACIO" varchar2(40),
"DENOMINACIO" mdsys.sdo_geometry,
"PERIMETRE_BASE" mdsys.sdo_geometry,
"PERIMETRE_SUPERIOR" mdsys.sdo_geometry,
"PUNT_BASE" mdsys.sdo_geometry,
primary key ("APB_ID"));

INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
VALUES ('EDIFICACIO', 'PUNT_BASE',
	MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', 40.9999999999999964, 41.5000000000000035, 1.00000000000000000e-006),
			MDSYS.SDO_DIM_ELEMENT('Y', 2.00000000000000000, 2.50000000000000000, 1.00000000000000000e-006)),
	4326)
;
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
VALUES ('EDIFICACIO', 'DENOMINACIO',
	MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', 40.9999999999999964, 41.5000000000000035, 1.00000000000000000e-006),
			MDSYS.SDO_DIM_ELEMENT('Y', 2.00000000000000000, 2.50000000000000000, 1.00000000000000000e-006)),
	4326)
;
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
VALUES ('EDIFICACIO', 'PERIMETRE_BASE',
	MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', 40.9999999999999964, 41.5000000000000035, 1.00000000000000000e-006),
			MDSYS.SDO_DIM_ELEMENT('Y', 2.00000000000000000, 2.50000000000000000, 1.00000000000000000e-006)),
	4326)
;
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
VALUES ('EDIFICACIO', 'PERIMETRE_SUPERIOR',
	MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', 40.9999999999999964, 41.5000000000000035, 1.00000000000000000e-006),
			MDSYS.SDO_DIM_ELEMENT('Y', 2.00000000000000000, 2.50000000000000000, 1.00000000000000000e-006)),
	4326)
;
drop index "X__EDIFICACIO_PU_1";
CREATE INDEX "X__EDIFICACIO_PU_1" ON "EDIFICACIO" ("PUNT_BASE")
	INDEXTYPE IS MDSYS.SPATIAL_INDEX
	PARAMETERS('LAYER_GTYPE="MULTIPOINT"');
drop index "X__EDIFICACIO_DE_2";
CREATE INDEX "X__EDIFICACIO_DE_2" ON "EDIFICACIO" ("DENOMINACIO")
	INDEXTYPE IS MDSYS.SPATIAL_INDEX
	PARAMETERS('LAYER_GTYPE="MULTIPOINT"');
drop index "X__EDIFICACIO_PE_3";
CREATE INDEX "X__EDIFICACIO_PE_3" ON "EDIFICACIO" ("PERIMETRE_BASE")
	INDEXTYPE IS MDSYS.SPATIAL_INDEX
	PARAMETERS('LAYER_GTYPE="MULTIPOLYGON"');
drop index "X__EDIFICACIO_PE_4";
CREATE INDEX "X__EDIFICACIO_PE_4" ON "EDIFICACIO" ("PERIMETRE_SUPERIOR")
	INDEXTYPE IS MDSYS.SPATIAL_INDEX
	PARAMETERS('LAYER_GTYPE="MULTIPOLYGON"');


ALTER TABLE EDIFICACIO ADD (DENOMINACIO_TEXT VARCHAR2(100));

TRUNCATE TABLE "EDIFICACIO";
