flatten_and_copy_with_prefix() {
    local src_dir=$1
    local dst_dir=$2
    local prefix=$3

    # Recursively find all files in the source directory
    find "$src_dir" -type f | while read -r item; do
        if [ -e "$item" ]; then
            local base_name=$(basename "$item")
            local new_name="${prefix}_${base_name}"

            # Copy the file to the destination directory with a prefixed name
            cp "$item" "$dst_dir/$new_name"
        fi
    done
}

unzip_files_recursively() {
    local dir=$1

    # Find all .zip files recursively in the given directory
    find "$dir" -type f -name "*.zip" | while read -r zip_file; do
        # Extract to the current directory
        unzip -o "$zip_file" -d "$(dirname "$zip_file")"
        
        # Optionally, remove the original zip file after extraction
        # rm "$zip_file"
    done
}

# Get the current working directory
pwd_dir=$(pwd)

# Step 1: Unzip all .zip files recursively in the current directory and its subdirectories
unzip_files_recursively "$pwd_dir"

# Step 2: Flatten and copy all files into the current working directory with unique naming
for dir in "$pwd_dir"/*/; do
    if [ -d "$dir" ]; then
        prefix=$(basename "$dir")
        flatten_and_copy_with_prefix "$dir" "$pwd_dir" "$prefix"
    fi
done

echo "All .zip files have been unzipped, and all files have been flattened and copied into the current directory with unique prefixes."
