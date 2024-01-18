DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'hivemetastoredb') THEN
    CREATE DATABASE "hivemetastoredb";
  END IF;
END $$;