return {
  command = "just",
  args = {
    "--fmt",
    "--unstable",
    "-f",
    "$FILENAME",
  },
  stdin = false,
}
