import Cocoa

func getImageNameFromNum(num: Int?) -> String? {
	let rawNum = num
	var modNum: String?
	if rawNum! < 10 {
		modNum = "00" + "\(rawNum ?? 0)"
	}
	if rawNum! < 100 {
		modNum = "0" + "\(rawNum ?? 10)"
	}
	return modNum
}

getImageNameFromNum(num: 23)
