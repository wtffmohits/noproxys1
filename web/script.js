/* script.js */
const qrContainer = document.getElementById("qr-container");
const qrCodeBox = document.getElementById("qrcode");
const studentList = document.getElementById("studentList");
let generated = false;

function generateQR() {
  const code = document.getElementById("lectureCode").value.trim();
  if (!code) return;

  qrContainer.classList.remove("blur");
  qrCodeBox.innerHTML = "";
  QRCode.toCanvas(code, { width: 200 }, function (err, canvas) {
    if (err) console.error(err);
    qrCodeBox.appendChild(canvas);
    generated = true;
  });

  // Simulate student scans for now (replace with realtime logic)
  setTimeout(() => addStudent("John Doe", "BSCIT101"), 2000);
  setTimeout(() => addStudent("Priya Sharma", "BSCIT102"), 4000);
}

function completeLecture() {
  if (!generated) return;
  qrContainer.classList.add("blur");
  qrCodeBox.innerHTML = "";
  studentList.innerHTML = "";
  document.getElementById("lectureCode").value = "";
  generated = false;
}

function addStudent(name, roll) {
  // Here you can verify roll number against a real database before adding
  const li = document.createElement("li");
  li.textContent = `${name} (${roll})`;
  studentList.appendChild(li);
}