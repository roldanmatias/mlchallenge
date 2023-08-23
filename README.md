
# ML Challenge

Challenge creado para cuplir con la consiga del challenge de ML.

## Arquitectura
Model View View Model

## Unit Tests
Test sobre el parse del json de las respuestas de la búsqueda y de currencies.

## Packages usados
Solo integré el package SDWebImage para demostrar como utilizar un paquete.

En caso de no usar paquete podría cargar las imágenes de la siguiente manera:

Cell
```
DispatchQueue.global(qos: .background).async {
            if let url = URL(string: item.thumbnail), 
                let data = try? Data(contentsOf: url), 
                let image: UIImage = UIImage(data: data) {
                DispatchQueue.main.async {
                     cell.thumbnail.image = image
                }
            }
        }
```
Detail:
```
DispatchQueue.global(qos: .background).async {
            if let url = URL(string: item.thumbnail), 
                let data = try? Data(contentsOf: url), 
                let image: UIImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                }
            }
        }

```

## Nota
No vi necesario utilizar un package para las llamadas a la API pero en caso de ser neesario podría agregarlo.

## Falta implementar
Mejoras en UI
Unit Tests en caso de network error
