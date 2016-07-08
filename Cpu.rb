# CPU 中央处理器
require './Cpu_Bus.rb'
require './Control.rb'
require './ALU.rb'
class Cpu < Device
  def initialize dbus, abus, cbus
    super dbus, abus, cbus
    remove_instance_variable :@addr
    remove_instance_variable :@rw
    undef getAddr
    undef getRW
    
    @bus = Cpu_Bus.new # CPU内部总线
    @control = Control.new dbus, abus, cbus, @bus # 控制器
    @alu = ALU.new @bus, @bus, @bus # 运算器
    @bus << @control << @alu
  end
  
  def getData data # CPU获取的数据直接传给控制器
    @control.getData data
  end
  
  def start # 激活控制器
    @control.work
  end
end