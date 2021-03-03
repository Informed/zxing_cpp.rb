require 'mkmf'

ZXING_CPP = "#{File.dirname(__FILE__)}/zxing-cpp"
ZXING_CPP_BUILD = "#{ZXING_CPP}/build"

`cmake --version` rescue raise "zxing_cpp.rb installation requires cmake"

Dir.mkdir ZXING_CPP_BUILD unless File.exist? ZXING_CPP_BUILD
Dir.chdir ZXING_CPP_BUILD do
  `cmake -DBUILD_SHARED_LIBS:BOOL=OFF -DCMAKE_CXX_FLAGS="-fPIC" ..`
end

Dir.chdir ZXING_CPP_BUILD do
  `make`
end

cpp_include = File.join File.expand_path("#{ZXING_CPP}/core/src")
lib = File.expand_path "#{ZXING_CPP_BUILD}/libzxing.a"

$CPPFLAGS = %(-I#{cpp_include})
$DLDFLAGS = %(-lstdc++ #{lib})

POSSIBLE_DIRS = ['/usr/lib/libiconv.*', '/usr/local/Cellar/libiconv/1.16/lib/libiconv.*'].freeze
$DLDFLAGS << %( -liconv) if POSSIBLE_DIRS.any? { |dir| !Dir[dir].empty? }

create_makefile 'zxing/zxing'
