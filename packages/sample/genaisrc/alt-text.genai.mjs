script({
    files: "src/vision/apollo11.jpg",
    model: "vision",
})
defImages(env.files)
$`Generate an alt-text description for the images.`
