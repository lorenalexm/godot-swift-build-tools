# godot-swift-build-tools

`godot-swift-build-tools` was made to assist of the compilation of project files using [godot-swift](https://github.com/kelvin13/godot-swift) on a macOS system. With support for `Float16` seemingly not existing on Intel based macOS systems ([source](https://forums.swift.org/t/accepted-se-0277-float16/34121/4)), I wanted to find a way to build [godot-swift](https://github.com/kelvin13/godot-swift) projects without having to make changes to the original project.

With that goal in mind, this Dockerfile was built as a way to achieve that goal.

## Installation

This project is provided as a Docker container, making installation as easy as pulling the image from [DockerHub](https://hub.docker.com).

```bash
docker pull lorenalexm/godot-swift-build-tools
```

## Usage

Example usage for building a project:

```bash
docker run -it -v $(pwd):/build -e SWIFT_PRODUCT_NAME=my-awesome-project -e SWIFT_BUILD_TYPE=debug -e GODOT_PROJECT_LIBRARIES_DIRECTORY=Game/libraries -e GODOT_BUILD_TYPE=debug godot-swift-build-tools
```

## Parameters

This container provides a few parameters needed to successfully build your project. I have tried to keep them to a minimum, and self-explanitory.

| Parameter | Function |
| --- | --- |
| -e SWIFT_PRODUCT_NAME | The product name as defined in your `Package.swift` file. |
| -e SWIFT_BUILD_TYPE | Is this a (debug | release ) build? |
| -e GODOT_PROJECT_LIBRARIES_DIRECTORY | The relative location of the libraries directory in your [Godot](https://godotengine.org) project. |
| -e GODOT_BUILD_TYPE | Is this a (debug | release ) build? You may want this to match the `SWIFT_BUILD_TYPE` parameter. |

## Notes

`godot-swift-build-tools` uses the Python build script provided by the [godot-swift](https://github.com/kelvin13/godot-swift) project as a final build step. It may be important to note that the build script has been modified to allow receiving a `-w` or `--working-directory` argument. This argument if set allows the script to call `os.chdir` and set the directory to the specified path. This was a requirement to allow the container to have the script run from a directory seperate the main project; as the original script sets the working directory to the script's location.

Second important note, is that at present (Aug. 9th, 2021), I have not had the opportunity to test the compiled libraries within [Godot](https://godotengine.org) on any architecture. I will update/remove this notice when either I have had time to test, or hear positive report back from someone else. If you have had success using the builds from this script on macOS, please don't hesitate to let me know!

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)