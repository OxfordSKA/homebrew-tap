# This formula is based on casacore.rb found at:
# https://github.com/ska-sa/homebrew-tap

class Casacore < Formula
    desc "Suite of C++ libraries for radio astronomy data processing."
    homepage "https://github.com/casacore/casacore"
    url "https://github.com/casacore/casacore/archive/v2.4.0.tar.gz"
    sha256 "9ae749d604d037a5a7b13b9eb759dfb8e22a405dcdb61f67c0916d3fe78db39c"
    head "https://github.com/casacore/casacore.git"

    bottle do
      root_url "http://oskar.oerc.ox.ac.uk/homebrew-bottles"
      sha256 "b101225efa0d5cd27099a241b04182df4bc9af46df5f03ead2541b283500e79b" => :high_sierra
    end

    # Apply patches for casacore v2.4.0
    stable do
      # 1. Fix CMake for python3 bindings if using Python 3.6 from homebrew
      patch do
        url "https://gist.githubusercontent.com/bmort/7a00c0b1a0db3e1f37a79a498aac4018/raw/9756561b5b0bac0bc4bd45e47e27693b695b8ccd/python3.diff"
        sha256 "5839f30cd99e5d688664737d458e63893e38eab174e9728da056b04776b444e6"
      end
    end

    option "with-cxx11", "Build with C++11 support"

    depends_on "cmake" => :build
    depends_on "cfitsio"
    depends_on "homebrew/science/wcslib"
    depends_on "python" => :recommended
    depends_on "python3" => :optional
    depends_on "fftw"
    depends_on "hdf5"
    depends_on "readline"
    depends_on "casacore-data"
    depends_on :fortran

    if build.with?("python3")
      depends_on "boost-python" => ["with-python3"]
      depends_on "numpy" => ["with-python3"]
    elsif build.with?("python")
      depends_on "boost-python"
      depends_on "numpy"
    end

    def install
      # To get a build type besides "release" we need to change from superenv to std env first
      build_type = "release"
      mkdir_p "build/#{build_type}"
      cd "build/#{build_type}"
      cmake_args = std_cmake_args
      cmake_args.delete "-DCMAKE_BUILD_TYPE=None"
      cmake_args << "-DCMAKE_BUILD_TYPE=#{build_type}"
      cmake_args << "-DCXX11=ON" if build.with? "cxx11"

      if build.with? "python"
        cmake_args << "-DBUILD_PYTHON=ON"
        cmake_args << "-DPYTHON2_EXECUTABLE=/usr/local/bin/python2"
        cmake_args << "-DPYTHON2_LIBRARY=/usr/local/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib"
      else
        cmake_args << "-DBUILD_PYTHON=OFF"
      end

      if build.with? "python3"
        cmake_args << "-DBUILD_PYTHON3=ON"
        cmake_args << "-DPYTHON3_EXECUTABLE=/usr/local/bin/python3"
        cmake_args << "-DPYTHON3_LIBRARY=/usr/local/Frameworks/Python.framework/Versions/3.6/lib/libpython3.6.dylib"
      end

      cmake_args << "-DUSE_FFTW3=ON" << "-DFFTW3_ROOT_DIR=#{HOMEBREW_PREFIX}"
      cmake_args << "-DUSE_HDF5=ON" << "-DHDF5_ROOT_DIR=#{HOMEBREW_PREFIX}"
      cmake_args << "-DUSE_THREADS=ON" << "-DDATA_DIR=#{HOMEBREW_PREFIX}/share/casacore/data"
      system "cmake", "../..", *cmake_args
      system "make", "-j4", "install"
    end

    test do
      system bin/"findmeastable", "IGRF"
      system bin/"findmeastable", "DE405"
    end
  end
