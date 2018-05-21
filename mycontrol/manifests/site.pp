# Include a list of casses collected throu all hiera hierarchie levels
hiera_include('classes')


$mess = hiera('message')
notify {'message':
	message => $mess}
