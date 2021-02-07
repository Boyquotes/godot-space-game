import os
import sys
import random
import pygame as pg

min_stripe_size = 8
max_stripe_size = 30
max_color_change = 30

r = 120

colors = (pg.Color(c) for c in [
    "salmon",
    "firebrick",
    "tomato",

    "sienna",
    "sandybrown",
    "peachpuff",
    
    "gold",
    "darkkhaki",
    "beige",
    
    "chartreuse",
    "forestgreen",
    "aquamarine",

    "turquoise",
    "deepskyblue",
    "royalblue",

    "darkviolet",
    "orchid",
    "deeppink",

    "darkgray",
    "gainsboro",
    "whitesmoke"
])

def limited(v, mn=50, mx=255):
    return max(min(v, mx), mn)

def shifted_color(color):
    shift = random.randint(-max_color_change, max_color_change)
    return [limited(v + shift) for v in color]

def new_planet(initial_color, change_colors=True):
    image = pg.Surface((2 * r, 2 * r), pg.SRCALPHA, 32)

    # create gradient
    y = 0
    color = initial_color
    while y < 2 * r:
        h = random.randint(min_stripe_size, max_stripe_size)
        rect = pg.Rect(0, y, 2 * r, h)
        if change_colors:
            color = shifted_color(color)
        pg.draw.rect(image, color, rect)
        y += h

    # create mask
    key = (20, 20, 20)
    mask = image.copy()
    mask.fill((0, 0, 0))
    mask.set_colorkey(key)
    pg.draw.circle(mask, key, (r, r), r)

    # apply mask
    image.blit(mask, (0, 0))
    return image

def random_color(mn=50, mx=255):
    return [random.randint(mn, mx) for i in range(3)]

def planet_generator():
    for color in colors:
        yield new_planet(color)

def save(image, path=None):
    if path == None:
        i = 0
        template = "sprites/planets/planet-{i}.png"
        path = template.format(i=i)
        while os.path.exists(path):
            i += 1
            path = template.format(i=i)
    assert not os.path.exists(path)
    pg.image.save(image, path)
    command = f"magick convert {path} -transparent black {path}"""
    os.system(command)

def main():
    pg.init()
    pg.display.set_mode((10, 10), 0, 32)

    for p in planet_generator():
        save(p)
    backing = new_planet((255, 255, 255), False)
    save(backing, "sprites/planets/planet-backing.png")

if __name__ == "__main__":
    main()