# 公共模块
class Common_Meta
  Add_Size = 3 # 设备识别码位数
  Speed = 0.3 # 速度值越小越快,最小值为0
  Addr_Device = { # 外部设备识别码
    :CPU => "000",
    :RAM => "001",
    :IO => "010",
    :ROM => "011"
  }
  R_W = { # 控制码
    :Read  => "00000000",
    :Write => "00000001",
    :In    => "00000001",
    :Out   => "00000000",
    :Alu_Add => "00000000",
    :Alu_Lef => "00000010",
    :Alu_Rit => "00000011"
  }
  Register = {
    :Alu_RegX => "00000000",
    :Alu_RegY => "00000001"
  }
  CPU_Addr_Device = { # CPU 内部设备识别码
    :Control  => "000",
    :ALU_dbus => "100",
    :ALU_abus => "101",
    :ALU_cbus => "110"
  }
  OpCode = { # 操作码
    :In  => "00000000", # 输入
    :Add => "00000001", # 加
    :Mov => "00000010", # 转储
    :Lad => "00000011", # 加载
    :Jmp => "00000100", # 跳转
    :Out => "00000101", # 输出
    :Lef => "00000110", # 左移
    :Rit => "00000111", # 右移
    :Hlt => "00001000"  # 关机
  }
  
  def encode data # 格式化为8位二进制数据
    re = ("%08d" %[data.to_i.to_s(2).to_i])
    re = re[re.size - 8..re.size]
  end
end