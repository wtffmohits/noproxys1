import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-analytics.js";
import { getFirestore, collection, getDocs, query, where } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

const firebaseConfig = {
  apiKey: "AIzaSyCqQEBkKrONGJvufR9F-tgU7VUTKqpVy8k",
  authDomain: "rajputji0.firebaseapp.com",
  projectId: "rajputji0",
  storageBucket: "rajputji0.firebasestorage.app",
  messagingSenderId: "1062495598488",
  appId: "1:1062495598488:web:12a7f964ce69d6d2315ded",
  measurementId: "G-P54S8FXF4Y"
};

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const db = getFirestore(app);

const startBtn = document.getElementById('startBtn');
const endBtn = document.getElementById('endBtn');
const lectureCodeInput = document.getElementById('lectureCode');
const qrCodeImg = document.getElementById('qrCodeImg');
const timerEl = document.getElementById('timer');
const sessionStatus = document.getElementById('sessionStatus');
const studentCountEl = document.getElementById('studentCount');
const attendanceList = document.getElementById('attendanceList');
const notificationBadge = document.getElementById('notificationBadge');
const bellIcon = document.getElementById('bellIcon');
const notifDropdown = document.getElementById('notifDropdown');
const notifList = document.getElementById('notifList');
const historyBtn = document.getElementById('historyBtn');
const historyDropdown = document.getElementById('historyDropdown');
const historyList = document.getElementById('historyList');
const exportBtn = document.getElementById('exportBtn');
const exportDropdown = document.getElementById('exportDropdown');
const exportCsv = document.getElementById('exportCsv');
const exportPdf = document.getElementById('exportPdf');

let intervalId, countdown;
let students = [];
let history = {};
let qrInterval;

lectureCodeInput.addEventListener('input', () => {
  const code = lectureCodeInput.value.trim();
  startBtn.disabled = !code;
  endBtn.disabled = true;
  students = [];
  updateAttendanceUI();
  updateNotifications();
  updateExports();
});

bellIcon.addEventListener('click', () => notifDropdown.classList.toggle('hidden'));
historyBtn.addEventListener('click', () => {
  historyDropdown.classList.toggle('hidden');
  renderHistory();
});
exportBtn.addEventListener('click', () => exportDropdown.classList.toggle('hidden'));

async function startSession() {
  const code = lectureCodeInput.value.trim();
  if (!code) return;

  const tasksRef = collection(db, "Tasks");
  const q = query(tasksRef, where("scheduleCode", "==", code));
  const snapshot = await getDocs(q);

  if (snapshot.empty) {
    alert("Schedule code is invalid ❌");
    return;
  }

  startBtn.disabled = true;
  endBtn.disabled = false;
  lectureCodeInput.disabled = true;
  sessionStatus.textContent = 'Session Active';
  sessionStatus.classList.replace('inactive', 'active');
  students = [];
  updateAttendanceUI();
  updateNotifications();
  updateExports();

  countdown = 15;
  updateQRCode();
  qrInterval = setInterval(() => {
    countdown = 15;
    updateQRCode();
  }, 15000);

  intervalId = setInterval(() => {
    if (countdown > 0) countdown--;
    timerEl.textContent = countdown + 's';
  }, 1000);
}

function endSession() {
  clearInterval(intervalId);
  clearInterval(qrInterval);
  const code = lectureCodeInput.value.trim();
  history[code] = students.slice();
  lectureCodeInput.disabled = false;
  startBtn.disabled = false;
  endBtn.disabled = true;
  sessionStatus.textContent = 'Session Inactive';
  sessionStatus.classList.replace('active', 'inactive');
  timerEl.textContent = '--s';
  qrCodeImg.src = 'https://via.placeholder.com/300x300?text=QR+Code';
  updateExports();
}

function updateQRCode() {
  const seed = Math.random().toString(36).substr(2, 8);
  qrCodeImg.src = `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${encodeURIComponent(lectureCodeInput.value + '-' + seed)}`;
}

function recordAttendance(data) {
  students.push(data);
  updateAttendanceUI();
  updateNotifications();
  updateExports();
  notificationBadge.textContent = students.length;
}

function updateAttendanceUI() {
  studentCountEl.textContent = students.length;
  attendanceList.innerHTML = '';
  if (!students.length) {
    attendanceList.innerHTML = '<li>No students have been marked present yet</li>';
  } else {
    students.forEach(s => {
      const li = document.createElement('li');
      li.innerHTML = `<div class='student-name'>${s.name}</div><div class='student-id'>${s.id}</div><div class='timestamp'>${s.time}</div>`;
      attendanceList.appendChild(li);
    });
  }
}

function updateNotifications() {
  notifList.innerHTML = '';
  if (!students.length) {
    notifList.innerHTML = '<li>No records yet</li>';
  } else {
    students.forEach(s => {
      const li = document.createElement('li');
      li.textContent = `${s.name} - ${s.time}`;
      notifList.appendChild(li);
    });
  }
}

function renderHistory() {
  historyList.innerHTML = '';
  const codes = Object.keys(history);
  if (!codes.length) {
    historyList.innerHTML = '<li>No history</li>';
  } else {
    codes.forEach(code => {
      const li = document.createElement('li');
      li.textContent = `${code} (${history[code].length} attendees)`;
      historyList.appendChild(li);
    });
  }
}

function updateExports() {
  exportBtn.disabled = students.length === 0;
  if (students.length === 0) exportDropdown.classList.add('hidden');
}

exportCsv.addEventListener('click', () => {
  let csv = 'Name,ID,Time\n';
  students.forEach(s => csv += `${s.name},${s.id},${s.time}\n`);
  const blob = new Blob([csv], { type: 'text/csv' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = `${lectureCodeInput.value.trim()}_attendance.csv`;
  link.click();
  exportDropdown.classList.add('hidden');
});

exportPdf.addEventListener('click', () => {
  const { jsPDF } = window.jspdf;
  const doc = new jsPDF();
  doc.text(`Attendance for ${lectureCodeInput.value.trim()}`, 10, 10);
  let y = 20;
  students.forEach(s => {
    doc.text(`${s.name} (${s.id}) at ${s.time}`, 10, y);
    y += 10;
  });
  doc.save(`${lectureCodeInput.value.trim()}_attendance.pdf`);
  exportDropdown.classList.add('hidden');
});

startBtn.addEventListener('click', startSession);
endBtn.addEventListener('click', endSession);

setTimeout(() => {
  recordAttendance({ name: 'Quinn Wilson', id: 'STU6939', time: new Date().toLocaleTimeString() });
}, 8000);