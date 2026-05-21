// Inscripciones ICO - Scripts
document.addEventListener('DOMContentLoaded', () => {
    // Confirmacion de borrados
    document.querySelectorAll('form[data-confirm]').forEach(f => {
        f.addEventListener('submit', e => {
            if (!confirm(f.dataset.confirm)) e.preventDefault();
        });
    });

    // Buscar al vuelo
    document.querySelectorAll('.search-live').forEach(inp => {
        inp.addEventListener('input', () => {
            const q = inp.value.toLowerCase();
            const tbl = document.querySelector(inp.dataset.target);
            if (!tbl) return;
            tbl.querySelectorAll('tbody tr').forEach(tr => {
                tr.style.display = tr.textContent.toLowerCase().includes(q) ? '' : 'none';
            });
        });
    });

    // Inscripcion: seleccionar tarjetas
    const formInsc = document.getElementById('form-inscripcion');
    if (formInsc) {
        const cards = formInsc.querySelectorAll('.grupo-card');
        const totalLbl = document.getElementById('total-creditos');
        const cntLbl   = document.getElementById('total-materias');
        function recalc() {
            let cred = 0, n = 0;
            cards.forEach(c => {
                if (c.classList.contains('selected')) { cred += +c.dataset.creditos; n++; }
            });
            if (totalLbl) totalLbl.textContent = cred;
            if (cntLbl)   cntLbl.textContent   = n;
        }
        cards.forEach(c => {
            c.addEventListener('click', () => {
                const cbox = c.querySelector('input[type=checkbox]');
                cbox.checked = !cbox.checked;
                c.classList.toggle('selected', cbox.checked);
                recalc();
            });
        });
        recalc();
    }
});
