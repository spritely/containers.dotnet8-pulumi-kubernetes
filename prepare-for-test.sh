container_name=$1
copy_env_file=$2
source_dir=./src
destination_dir=test/$container_name/.devcontainer

mkdir -p $destination_dir
cp -r "$source_dir"/. "$destination_dir"
mv "$destination_dir/docker-compose.template" "$destination_dir/docker-compose.yml"
if [ "$copy_env_file" = "true" ]; then
  cp "test/$container_name/.devcontainer/.env.example" "test/$container_name/.devcontainer/.env"
fi
find "$destination_dir" -type f -exec sed -i "s/{repo-name}/test-${container_name}/g" {} +
