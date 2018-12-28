
DataMigration/
        scripts/
        config/
        logs/
        temp/
        output/
        Pseudocode.txt
        Readme.txt


Pseudocode
scripts/TD2BQSchema.py

1. Get metadata from TD and save it in temp folder (overwrite if existing)
2. Create json file from TD metadata ( in output folder )
3. Use json file ( BQ schema) to create BQ table ( if having direct access to BQ)
4. Clear metadata file, keep BQ schema json file for future use

