import random
import pygame as pg

width = 500
height = 500
density = 0.001
radius = 1

def generate_layer():
    stars = round(density * width * height)
    image = pg.Surface((width, height))
    for i in range(stars):
        x = random.randint(0, width)
        y = random.randint(0, height)
        pg.draw.circle(image, (255, 255, 255), (x, y), radius)
    return image

def save(img, path="sprites/background.png"):
    pg.image.save(img, path)

def main():
    l = generate_layer()
    save(l)

if __name__ == "__main__":
    main()
