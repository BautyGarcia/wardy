# Supabase Setup for Wardy App

This guide will help you set up Supabase for the Wardy clothing app.

## 1. Create a Supabase Project

1. Go to [Supabase](https://supabase.com/) and sign up or log in.
2. Create a new project by clicking "New Project".
3. Enter a name for your project and set a secure database password.
4. Choose a region closest to your users.
5. Click "Create new project" and wait for it to be created.

## 2. Set Up Database Tables

1. In your Supabase project dashboard, go to the "SQL Editor" section.
2. Copy and paste the contents of the `supabase_setup.sql` file from this project.
3. Run the SQL script to create the necessary tables and policies.

## 3. Set Up Storage

1. In your Supabase project dashboard, go to the "Storage" section.
2. Click "Create a new bucket".
3. Name the bucket `clothing_images`.
4. Set the privacy setting to "Public" to allow public access to the images.
5. Click "Create bucket".

## 4. Configure Access Policies for Storage

1. In the Storage section, select the `clothing_images` bucket.
2. Go to the "Policies" tab.
3. Add the following policies:

### For reading files:
- Click "Add Policy"
- Select "For SELECT operations (read)" from the dropdown
- Policy name: "Allow public read access"
- Policy definition: Select "Custom policy" and enter `true` (to allow anyone to read files)
- Click "Save Policy"

### For inserting files:
- Click "Add Policy"
- Select "For INSERT operations (create)" from the dropdown
- Policy name: "Allow anonymous uploads"
- Policy definition: Select "Custom policy" and enter `true` (for the demo app without authentication)
- Click "Save Policy"
- Note: In a production app, you might want to restrict this to authenticated users with `auth.role() = 'authenticated'`

### For updating files:
- Click "Add Policy"
- Select "For UPDATE operations (update)" from the dropdown
- Policy name: "Allow anonymous updates"
- Policy definition: Select "Custom policy" and enter `true` (for the demo app without authentication)
- Click "Save Policy"
- Note: In a production app, you might want to restrict this to authenticated users with `auth.role() = 'authenticated'`

### For deleting files:
- Click "Add Policy"
- Select "For DELETE operations (delete)" from the dropdown
- Policy name: "Allow anonymous deletes"
- Policy definition: Select "Custom policy" and enter `true` (for the demo app without authentication)
- Click "Save Policy"
- Note: In a production app, you might want to restrict this to authenticated users with `auth.role() = 'authenticated'`

## 5. Test the Storage Setup

1. After setting up the bucket and policies, you can test it by:
   - Going to the "Storage" section in the Supabase dashboard
   - Selecting the `clothing_images` bucket
   - Clicking "Upload File" and uploading a test image
   - Verifying you can view the image by clicking on it

2. The URL of the uploaded image should follow this pattern:
   `https://[YOUR_PROJECT_ID].supabase.co/storage/v1/object/public/clothing_images/[FILENAME]`

3. You should be able to access this URL directly in your browser to confirm the image is publicly accessible.

## 6. Get API Credentials

1. In your Supabase project dashboard, go to the "Settings" section.
2. Click on "API" in the sidebar.
3. You'll find your:
   - Project URL (e.g., `https://abcdefghijklm.supabase.co`)
   - `anon` public key

## 7. Update the App Configuration

1. Copy the `.env.example` file to a new file named `.env`:
   ```bash
   cp .env.example .env
   ```

2. Open the `.env` file and replace the placeholder values with your actual Supabase credentials:
   ```
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   ```

   You can find these values in your Supabase project dashboard under Settings > API.

## 8. Run the App

Now you can run your app with Supabase integration!

## Troubleshooting

### Storage Issues
- If you encounter errors related to storage access, double-check that:
  1. The bucket name is exactly `clothing_images` (case sensitive)
  2. The bucket is set to "Public"
  3. All four policies (SELECT, INSERT, UPDATE, DELETE) are properly configured
  4. You're using the correct Supabase URL and anon key in your app

### Database Issues
- If you encounter errors related to database access, verify that:
  1. The SQL script was executed successfully
  2. The RLS policies are properly configured
  3. You're using the correct Supabase URL and anon key in your app

## Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Flutter SDK Documentation](https://supabase.com/docs/reference/dart/introduction)
- [Flutter Storage Guide](https://supabase.com/docs/guides/storage/uploads) 