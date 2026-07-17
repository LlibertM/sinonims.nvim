# sinonims.nvim

Plugin de Neovim per a consultar el *Diccionari de sinònims d'Albert Jané* fora de línia i directament des de l'editor.

Permet consultar els sinònims de la paraula sota el cursor o d'un text seleccionat en mode visual.

## Instal·lació

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "LlibertM/sinonims.nvim",
    config = function()
        require("sinonims").setup()
    end,
}
```

## Crèdits

Les dades utilitzades per aquest *plugin* provenen de la tercera edició en línia del *Diccionari de sinònims d'Albert Jané*, publicada per la Secció Filològica de l'Institut d'Estudis Catalans i accessible des del web <https://sinonims.iec.cat>.

El diccionari es distribueix sota la llicència Creative Commons Reconeixement-NoComercial-SenseObraDerivada 3.0 (CC BY-NC-ND 3.0).

Aquesta llicència permet reproduir, distribuir i comunicar públicament l'obra sempre que se'n reconegui l'autoria, no se'n faci un ús comercial i no se'n creïn obres derivades.

Així mateix, per a la implementació d'aquest *plugin* s'han utilitzat els fitxers de dades en format DSL publicats per [Diccionari de sinònims d'Albert Jané, fora de línia](https://orga.cat/blog/diccionari-sinonims-albert-jane-fora-linia/) (el mateix autor atribueix la procedència de les dades a les fonts abans mencionades).

Aquestes dades s'han processat i adaptat al format utilitzat pel *plugin* `sinonims.nvim`.

### Autoria i edició del diccionari

- Albert Jané i Riera — autor.
- Institut d'Estudis Catalans — edició en línia.
