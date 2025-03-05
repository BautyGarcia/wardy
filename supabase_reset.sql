-- Drop the existing table if it exists
DROP TABLE IF EXISTS clothing_items CASCADE;

-- Create the clothing_items table with correct lowercase column names
CREATE TABLE clothing_items (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  imagepath TEXT NOT NULL,
  dateadded TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  metadata JSONB
);

-- Enable Row Level Security
ALTER TABLE clothing_items ENABLE ROW LEVEL SECURITY;

-- Create a policy that allows all users to select clothing items
CREATE POLICY "Allow public read access" ON clothing_items
  FOR SELECT USING (true);

-- Create a policy that allows anonymous users to insert clothing items
-- This is needed for the demo app without authentication
CREATE POLICY "Allow anonymous users to insert" ON clothing_items
  FOR INSERT WITH CHECK (true);

-- Create a policy that allows anonymous users to update clothing items
-- This is needed for the demo app without authentication
CREATE POLICY "Allow anonymous users to update" ON clothing_items
  FOR UPDATE USING (true);

-- Create a policy that allows anonymous users to delete clothing items
-- This is needed for the demo app without authentication
CREATE POLICY "Allow anonymous users to delete" ON clothing_items
  FOR DELETE USING (true);

-- Create an index on the category column for faster filtering
CREATE INDEX idx_clothing_items_category ON clothing_items(category);

-- Create an index on the dateadded column for faster sorting
CREATE INDEX idx_clothing_items_date_added ON clothing_items(dateadded);

-- Note: After running this script, you still need to:
-- 1. Create a storage bucket named 'clothing_images'
-- 2. Set the bucket to public
-- 3. Add policies for SELECT, INSERT, UPDATE, and DELETE operations 