async function loadGroupsForSelect() {
    try {
        const response = await fetchWithAuth('groups');
        if (!response.ok) {
            console.warn('Не удалось загрузить группы');
            return;
        }

        const groups = await response.json();
        const select = document.getElementById('dynUserGroupId');
        if (!select) return;

        select.innerHTML = '<option value="">Не назначена</option>' +
            groups.map(g => `<option value="${g.id}">${g.name} (${g.course} курс)</option>`).join('');

        console.log('Загружено групп:', groups.length);
    } catch (error) {
        console.error('Error loading groups:', error);
    }
}
