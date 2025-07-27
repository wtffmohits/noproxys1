// app.js
import { db } from './firebase-config.js';
import { collection, addDoc } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

let studentData = [];

document.getElementById('previewBtn').addEventListener('click', () => {
  const fileInput = document.getElementById('excelFile');
  const file = fileInput.files[0];

  if (!file) return alert("Please select an Excel file.");

  const reader = new FileReader();
  reader.onload = function (e) {
    const data = new Uint8Array(e.target.result);
    const workbook = XLSX.read(data, { type: 'array' });

    const sheet = workbook.Sheets[workbook.SheetNames[0]];
    studentData = XLSX.utils.sheet_to_json(sheet);

    // Render Table
    const table = document.getElementById('previewTable');
    table.innerHTML = '';

    const headers = Object.keys(studentData[0]);
    const thead = document.createElement('thead');
    const headRow = document.createElement('tr');
    headers.forEach(header => {
      const th = document.createElement('th');
      th.textContent = header;
      headRow.appendChild(th);
    });
    thead.appendChild(headRow);
    table.appendChild(thead);

    const tbody = document.createElement('tbody');
    studentData.forEach(row => {
      const tr = document.createElement('tr');
      headers.forEach(header => {
        const td = document.createElement('td');
        td.textContent = row[header];
        tr.appendChild(td);
      });
      tbody.appendChild(tr);
    });
    table.appendChild(tbody);
  };
  reader.readAsArrayBuffer(file);
});

document.getElementById('uploadBtn').addEventListener('click', async () => {
  if (studentData.length === 0) {
    alert("No data to upload.");
    return;
  }

  const batch = prompt("Enter Batch (e.g., Batch-A):");
  const dept = prompt("Enter Department (e.g., bscit):");

  const colRef = collection(db, `Collages/Thakur Shyamnarayan Degree Collage/students/${dept}/Devision/${batch}/student-id`);

  try {
    for (const student of studentData) {
      await addDoc(colRef, student);
    }
    alert("✅ Data uploaded to Firebase successfully!");
  } catch (error) {
    console.error(error);
    alert("❌ Error uploading data.");
  }
});
