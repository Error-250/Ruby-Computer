# Device设备
require './common.rb'
class Device < Common_Meta
  # 要求每个设备都必须连接数据总线，地址总线和控制总线
  def initialize dbus, abus, cbus
    @dbus = dbus
    @abus = abus
    @cbus = cbus
    
    @in_data = nil     # 待处理数据
    @addr    = nil     # 地址数据
    @rw      = 0       # 控制
  end
  
  def getData data # 从数据总线获取数据
    @in_data = data
  end
  
  def getAddr data # 从地址总线获取地址
    @addr = data
  end
  
  def getRW data # 从控制总线获取控制信息
    @rw = data.to_i(2)
    work # 激活设备
  end
  
  def work;end # 设备激活并工作
end