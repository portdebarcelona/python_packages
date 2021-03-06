import unittest
from functools import reduce

import osgeo_utils
import os

path_project = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
path_data = os.path.join(path_project, 'resources/data')


class TestOsgeoUtils(unittest.TestCase):
    ds_gpkg, overwrite = osgeo_utils.datasource_gdal_vector_file(
        'GPKG', 'edificacio', path_data)

    def test_open_ds_gpkg(self):
        self.assertIsNotNone(self.ds_gpkg)

    def test_layer_gpkg(self):
        lyr = self.ds_gpkg.GetLayerByName('edificacio-perimetre_base')
        self.assertIsNotNone(lyr)

    def test_layer_geojson(self):
        ds, ovrwrt = osgeo_utils.datasource_gdal_vector_file(
            'GeoJSON', 'edificacio-perimetre_base.geo', path_data)
        lyr = ds.GetLayer(0)
        self.assertIsNotNone(lyr)

    def test_layer_csv(self):
        ds, ovrwrt = osgeo_utils.datasource_gdal_vector_file(
            'CSV', 'edificacio.zip', path_data, create=False, from_zip=True)
        lyr = ds.GetLayer(0)
        self.assertIsNotNone(lyr)

    def test_copy_layer(self):
        ds_dest, ovrwrt = osgeo_utils.datasource_gdal_vector_file(
            'CSV', 'edificacio-perimetre_superior', path_data, create=True)
        lyr_orig = self.ds_gpkg.GetLayerByName('edificacio-perimetre_superior')
        lyr_dest = osgeo_utils.copy_layer_gdal_to_ds_gdal(lyr_orig, ds_dest)
        self.assertIsNotNone(lyr_dest)
        self.assertEqual(lyr_orig.GetFeatureCount(), lyr_dest.GetFeatureCount())

    def test_postgis_conn(self):
        ds = osgeo_utils.ds_postgis(
            dbname='GIS', host='db_pg_pyckg', port=5432, user='eam', password='eam123')
        self.assertIsNotNone(ds)

    def test_add_layer_mono_geom_to_postgis(self):
        lyr_orig = self.ds_gpkg.GetLayerByName('edificacio-perimetre_superior')
        ds = osgeo_utils.ds_postgis(
            dbname='GIS', host='db_pg_pyckg', port=5432, user='eam', password='eam123')
        lyrs_dest = osgeo_utils.add_layer_gdal_to_ds_gdal(
            ds, lyr_orig, nom_layer='edificacio', nom_geom='perimetre_superior', overwrite='OVERWRITE=YES')
        self.assertIsNotNone(lyrs_dest)
        self.assertEqual(lyr_orig.GetFeatureCount(),
                         reduce(sum, [lyr_dest.GetFeatureCount() for lyr_dest in lyrs_dest]))

    def test_add_layer_multi_geom_to_postgis(self):
        ds_csv, ovrwrt = osgeo_utils.datasource_gdal_vector_file(
            'CSV', 'edificacio.zip', path_data, create=False, from_zip=True)
        lyr_orig = ds_csv.GetLayer(0)

        ds = osgeo_utils.ds_postgis(
            dbname='GIS', host='db_pg_pyckg', port=5432, user='eam', password='eam123')
        lyrs_dest = osgeo_utils.add_layer_gdal_to_ds_gdal(
            ds, lyr_orig, nom_layer='edificacio', multi_geom=True,
            overwrite='OVERWRITE=YES', promote_to_multi='PROMOTE_TO_MULTI=YES')
        self.assertIsNotNone(lyrs_dest)
        self.assertEqual(lyr_orig.GetFeatureCount(),
                         reduce(sum, [lyr_dest.GetFeatureCount() for lyr_dest in lyrs_dest]))


if __name__ == '__main__':
    unittest.main()
