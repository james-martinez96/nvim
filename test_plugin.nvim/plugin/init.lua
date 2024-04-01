local docker = require("docker")

vim.api.nvim_create_user_command("Docker", function()
  docker.show_docker_images({})
end, {})

vim.api.nvim_create_user_command("DockerContainerList", function()
  docker.list_containers({})
end, {})
