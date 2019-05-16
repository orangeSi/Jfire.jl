function FA()
	this.name = "world"
	return "hello"
end
function FB(f::Function)
    println(f.name)
end
FB(FA())

