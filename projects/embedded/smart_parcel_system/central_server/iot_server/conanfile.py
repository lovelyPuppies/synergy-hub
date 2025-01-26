from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout, CMakeDeps
from conan.errors import ConanInvalidConfiguration
from conan.tools.build import check_max_cppstd, check_min_cppstd


class iot_serverRecipe(ConanFile):
    name = "iot_server"
    version = "1.0"
    package_type = "application"

    # Optional metadata
    license = "<Put the package license here>"
    author = "wbfw109v2 wbfw109v2@gmail.com"
    url = "<Package recipe repository url here, for issues about the package>"
    description = "<Description of iot_server package here>"
    topics = ("<Put some tag here>", "nanoPB", "EPoll", "Multithreading")

    # Binary configuration
    settings = "os", "compiler", "build_type", "arch"

    # Sources are located in the same place as this recipe, copy them to the recipe
    exports_sources = "CMakeLists.txt", "src/*"

    def layout(self):
        ## ☑️ [question] preset name != profile name ; https://github.com/conan-io/conan/issues/16557
        # tools.cmake.cmake_layout:build_folder_vars=["settings.build_type", "settings.compiler"]
        # https://docs.conan.io/2.0/tutorial/creating_packages/handle_sources_in_packages.html#sources-from-a-zip-file-stored-in-a-remote-repository
        self.folders.build_folder_vars = ["settings.build_type", "settings.compiler"]
        cmake_layout(self)

    def generate(self):
        deps = CMakeDeps(self)
        deps.generate()
        tc = CMakeToolchain(self)
        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()

    # def validate(self):
    #     check_min_cppstd(self, "23")
    #     check_max_cppstd(self, "23")
