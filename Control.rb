# Control 控制器
require './Device.rb'

class PC # PC 指令寄存器
  def initialize s
    @pc = s
  end
  
  def setPC pc
    @pc = pc
  end
  
  def work
    @pc = @pc.next
    @pc.pred
  end
end

class Control < Device
  alias setData getData
  def initialize dbus, abus, cbus, bus
    super dbus, abus, cbus
    @bus = bus # cpu内部总线
    @pc = PC.new 128
    @ir = nil
    @halt = false
  end
  
  def getAddrs rawAdd # 原生地址返回实际地址和目标识别码
    target = ""
    if rawAdd[0] == '0'
      target = Addr_Device[:RAM]
    else
      target = Addr_Device[:ROM]
    end
    rawAdd[0] = "0"
    {:target => target, :addr => rawAdd}
  end
  
  def getCode # 取指
    addr = getAddrs encode(@pc.work) # 下一条指令的地址
    @abus.setData addr[:target] + addr[:addr] # 向存储器给出地址
    @cbus.setData addr[:target] + R_W[:Read]  # 向存储器给出控制信号
    @ir = @in_data # 获取从存储器读取的数据
  end
  
  def code_decode # 指令译码器
    case @ir
      when OpCode[:In]  then code_in
      when OpCode[:Add] then code_add
      when OpCode[:Mov] then code_mov
      when OpCode[:Lad] then code_lad
      when OpCode[:Jmp] then code_jmp
      when OpCode[:Out] then code_out
      when OpCode[:Lef] then code_lef
      when OpCode[:Rit] then code_rit
      when OpCode[:Hlt] then code_hlt
    end
  end
  
  def work
    while not @halt
      getCode     # 取指
      code_decode # 译码
      sleep(Speed)# 时序控制(太假了~~)
    end
  end
  
  def code_in # IN指令
    addr = getAddr_fromMem
    @cbus.setData Addr_Device[:IO] + R_W[:In]
    setData_toMem addr, @in_data
  end
  
  def code_add # ADD指令
    addr = getAddr_fromMem
    getData_fromMem addr
    setData_toAlu Register[:Alu_RegX], @in_data
    
    addr = getAddr_fromMem
    getData_fromMem addr
    setData_toAlu Register[:Alu_RegY], @in_data
    
    @bus.setData CPU_Addr_Device[:ALU_cbus] + R_W[:Alu_Add]
    
    setData_toMem addr, @in_data
  end
  
  def code_mov # Mov指令
    addr = getAddr_fromMem
    getData_fromMem addr
    data = @in_data
    addr = getAddr_fromMem
    setData_toMem addr, data
  end
  
  def code_lad # Lad指令
    addr = getAddr_fromMem
    f = open("./start.sys")
    f.each_line do |line|
      setData_toMem addr, line.rstrip # 载入内存
      addr[:addr] = addr[:addr].to_i(2).next # 下一条地址
      addr[:addr] = encode addr[:addr]
    end
  end
  
  def code_jmp # Jmp指令
    getCode # 获取跳转地址
    addr = @ir
    @pc.setPC addr.to_i(2) # 修改PC值
  end
  
  def code_out # Out指令
    addr = getAddr_fromMem
    getData_fromMem addr
    @dbus.setData Addr_Device[:IO] + @in_data
    @cbus.setData Addr_Device[:IO] + R_W[:Out]
  end
  
  def code_lef # Lef指令
    addr = getAddr_fromMem
    getData_fromMem addr
    setData_toAlu Register[:Alu_RegX], @in_data
    @bus.setData CPU_Addr_Device[:ALU_cbus] + R_W[:Alu_Lef]
    setData_toMem addr, @in_data
  end
  
  def code_rit # Rit指令
    addr = getAddr_fromMem
    getData_fromMem addr
    setData_toAlu Register[:Alu_RegX], @in_data
    @bus.setData CPU_Addr_Device[:ALU_cbus] + R_W[:Alu_Rit]
    setData_toMem addr, @in_data
  end
  
  def code_hlt # Hlt指令
    @halt = true
  end
  
  def getAddr_fromMem # 从存储器读取一个地址信息
    getCode
    getAddrs @ir
  end
  
  def getData_fromMem addr # 根据地址从存储器读取信息
    @abus.setData addr[:target] + addr[:addr]
    @cbus.setData addr[:target] + R_W[:Read]
  end
  
  def setData_toMem addr, data # 向存储器写数据
    @dbus.setData addr[:target] + data
    @abus.setData addr[:target] + addr[:addr]
    @cbus.setData addr[:target] + R_W[:Write]
  end
  
  def setData_toAlu addr, data # 向ALU的寄存器写数据
    @bus.setData CPU_Addr_Device[:ALU_dbus] + data
    @bus.setData CPU_Addr_Device[:ALU_abus] + addr
    @bus.setData CPU_Addr_Device[:ALU_cbus] + R_W[:Write]
  end
end
