# 计算机
require './Cpu.rb'
require './common.rb'
require './Dbus.rb'
require './Abus.rb'
require './Cbus.rb'
require './ROM.rb'
require './Memory.rb'
require './IO.rb'

class Computer
  def initialize
    @dbus = DBus.new # 数据总线
    @abus = ABus.new # 地址总线
    @c_bus = CBus.new # 控制总线
    @cpu = Cpu.new @dbus, @abus, @c_bus # CPU
    @rom = ROM.new @dbus, @abus, @c_bus# ROM
    @memory = Memory.new @dbus, @abus, @c_bus# 主存RAM 8位* 128
    @io = Io.new @dbus, @abus, @c_bus# 输入输出设备
    init
  end
  
  def init # 连接总线
    @dbus << @cpu << @memory << @io << @rom
    @abus << @cpu << @memory << @io << @rom
    @c_bus << @cpu << @memory << @io << @rom
  end
  
  def start
    @cpu.start
  end
end

c = Computer.new
c.start