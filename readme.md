# A View from Gazebo

![Cover Photo](images/cover.gif)

# Build & Run


```bash
git clone https://github.com/milchchocolate/view_from_gazebo.git
cd view_from_gazebo
./run-gazebo.sh
```

> Wait till `READY` appears on terminal inside container

```bash
(container) mkdir src/build && cd src/build
(container) cmake ..
(container) cmake --build . -j 4 --target install --config Release
(container) gazebo -u camera_calibration_move_model.world --verbose
```

Simulator starts in <u>paused</u> state. Click play button to start simulation.

# Development in container with VS Code

Ref: [VS Code: Remote development in Containers](https://code.visualstudio.com/docs/remote/containers-tutorial#_install-the-extension)

## Steps
- Run container using script: `run-gazebo.sh` (keep it running)
- Install [`Remote - Containers` extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) in VS Code
- From VS Code, attach to a running container:
  - open a remote window: click the status bar item (bottom-left)
  - click `Attach to a running container...`
  - select `gazebo-vm`

- Install extensions:
  - [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)

  - [CppTools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)

  - [Clang-Format](https://marketplace.visualstudio.com/items?itemName=xaver.clang-format)

  - [Clang-Tidy](https://marketplace.visualstudio.com/items?itemName=notskm.clang-tidy)

## CMake
CMake Version used in project is 3.15. [see features](https://cliutils.gitlab.io/modern-cmake/chapters/intro/newcmake.html).<br>
Ref: [An Introduction to Modern CMake](https://cliutils.gitlab.io/modern-cmake/)
