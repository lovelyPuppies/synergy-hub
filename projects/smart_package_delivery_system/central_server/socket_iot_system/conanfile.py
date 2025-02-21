from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout, CMakeDeps
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

    # options = {
    #     "custom_suffix": ["", "raspberry_pi", "x86"],
    # }
    # default_options = {
    #     "custom_suffix": "",
    # }

    # def requirements(self):
        
    # Convert Integer to enum value.

    def layout(self):
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

    def validate(self):
        check_min_cppstd(self, "17")
        check_max_cppstd(self, "23")
