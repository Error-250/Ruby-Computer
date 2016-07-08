# 代码生成器，有强迫症的自行修改
OpCode = { # 操作码
  :In  => "00000000", # 输入
  :Add => "00000001", # 加
  :Mov => "00000010", # 转储
  :Lad => "00000011", # 加载
  :Jmp => "00000100", # 跳转
  :Out => "00000101", # 输出
  :Lef => "00000110", # 左移
  :Rit => "00000111", # 右移
  :Hlt => "00001000", # 关机
  :Dat => ""
}

def encode addr
  re = ("%08d" %[addr.to_i.to_s(2).to_i])
  re[re.size-8..re.size]
end

def Data *args
  args.each do |a|
    @code << encode(a) + "\n"
  end
end
@code = []
def method_missing method_name, *args, &block
  if OpCode.has_key? method_name
    str = OpCode[method_name.to_sym] + "\n"
    args.each do |a|
      str += encode a
      str += "\n"
    end
    @code << str
  end
end
# 下面是跑马灯程序示例
load './code.txt'

f = open("./start.sys","w")
f.puts @code.join("")
f.close