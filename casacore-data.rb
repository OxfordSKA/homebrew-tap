# This formula is based on casacore-data.rb found at:
# https://github.com/ska-sa/homebrew-tap

class CasacoreData < Formula
  homepage 'https://github.com/casacore/casacore'
  url 'ftp://ftp.astron.nl/outgoing/Measures/WSRT_Measures_20171106-000001.ztar'
  sha256 "48a53785d96cd4ae203dbc07998af020e5413c260be4692914a564a80eaa6d81"
  head 'ftp://ftp.astron.nl/outgoing/Measures/WSRT_Measures.ztar'

  option 'use-casapy', 'Use Mac CASA.App data directory if found'

  def casapy_data; '/Applications/CASA.app/Contents/data'; end

  def install
    if (build.include? 'use-casapy') and (File.exists? casapy_data+'/ephemerides')
      mkdir_p "#{share}/casacore"
      ln_s "#{casapy_data}", "#{share}/casacore/data"
    else
      mkdir_p "#{share}/casacore/data"
      cp_r Dir['*'], "#{share}/casacore/data/"
    end
  end

  def caveats
    if File.symlink? "#{share}/casacore/data"
      "Linked to CASA data directory #{casapy_data}"
    else
      "Installed WSRT measures archive tarball from ASTRON FTP server"
    end
  end
end