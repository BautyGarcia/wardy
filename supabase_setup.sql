-- Create the clothing_items table
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

-- Create a storage bucket for clothing images
-- Note: This is typically done through the Supabase dashboard or API, not SQL
-- But this serves as a reminder to create the bucket

-- Create an index on the category column for faster filtering
CREATE INDEX idx_clothing_items_category ON clothing_items(category);

-- Create an index on the dateadded column for faster sorting
CREATE INDEX idx_clothing_items_date_added ON clothing_items(dateadded);

-- Storage bucket setup instructions (to be executed in the Supabase dashboard)
/*
1. Go to Storage in the Supabase dashboard
2. Create a new bucket named 'clothing_images'
3. Set the bucket to public
4. Add the following policies:

For SELECT (read) operations:
- Policy name: "Allow public read access"
- Policy definition: true

For INSERT operations:
- Policy name: "Allow anonymous uploads"
- Policy definition: true

For UPDATE operations:
- Policy name: "Allow anonymous updates"
- Policy definition: true

For DELETE operations:
- Policy name: "Allow anonymous deletes"
- Policy definition: true
*/ 