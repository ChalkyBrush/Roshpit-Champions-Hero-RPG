from pathlib import Path


ITEMLOADER_PATH = 'Content/panorama/layout/custom_game/itemloader2.xml'
IMAGES_PATH = 'Content/panorama/images/items'
IMAGE_PATTERN = '*.png'


def get_image_tag(filepath):
    rel_path = str(filepath.relative_to('Content/panorama/images')).replace('\\', '/')
    return f'\t\t<Image id="seq_bg" class="SeqBg" src="file://{{images}}/{rel_path}"/>\n'
    

def update_itemloader(filepaths):
    with Path(ITEMLOADER_PATH).open('w', encoding='utf-8') as itemloader:
        itemloader.write('<root>\n' +
                         '\t<styles>\n' +
                         '\t\t<include src="file://{resources}/styles/custom_game/equipment.css" />\n'+
	                     '\t</styles>\n'+ 
                         '\t<Panel class="ItemLoaderRoot">\n')
        for file in filepaths:
            line = get_image_tag(file)
            itemloader.write(line)
        itemloader.write('\t</Panel>\n</root>\n')
    

if __name__ == '__main__':
    filepaths = Path(IMAGES_PATH).rglob(IMAGE_PATTERN)
    update_itemloader(filepaths)