# io 输入输出设备
require './Device.rb'

class Io < Device
  def initialize dbus, abus , cbus
    super dbus, abus, cbus
    remove_instance_variable :@addr # 移除地址数据
    undef getAddr
  end
  
  def work # 激活
    if @rw == 1 # 输入
      @in_data = gets.rstrip
      @dbus.setData Addr_Device[:CPU] + @in_data
    else
      puts @in_data
    end
  end
end
# Ready