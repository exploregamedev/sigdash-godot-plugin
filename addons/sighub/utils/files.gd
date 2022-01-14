extends Reference
class_name Files

static func get_files_in_dir(rootPath: String, file_ext_filters=[]) -> Array:
	var files = []
	var dir = Directory.new()

	if dir.open(rootPath) == OK:
		dir.list_dir_begin(true, true)
		_add_dir_contents(dir, files, file_ext_filters)
	else:
		push_error("An error occurred when trying to access the path.")
	return files


static func _add_dir_contents(dir: Directory, files: Array, file_ext_filters):
	var file_name = dir.get_next()
	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name
		if dir.current_is_dir():
			var subDir = Directory.new()
			subDir.open(path)
			subDir.list_dir_begin(true, false)
			_add_dir_contents(subDir, files, file_ext_filters)
		else:
			if _is_sought_file_type(file_name, file_ext_filters):
				files.append(path)
		file_name = dir.get_next()
	dir.list_dir_end()


static func _is_sought_file_type(filename: String, file_ext_filters):
	if not file_ext_filters:
		return true
	return filename.get_extension() in file_ext_filters
