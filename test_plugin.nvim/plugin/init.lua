local docker = require("docker")

vim.api.nvim_create_user_command("Docker", function()
  docker.show_docker_images()
end, {})
