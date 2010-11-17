
$io = StringIO.new("")

# Some replacing of methods to block real world interaction
class EC2Command 
	def puts *args
		$io.puts *args
	end
end

class EC2Instance
	def exec *args
		$io.puts *args
	end
end
