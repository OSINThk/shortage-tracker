let clientRelationshipID = 100;

function walk(node, callback) {
  callback(node)

  // Update the template contents.
  for (let i = 0; i < node.children.length; i++) {
    walk(node.children[i], callback);
  }

  // Update child templates.
  if (node.content instanceof DocumentFragment) {
    walk(node.content, callback);
  }
}

function updateAttributes(slug) {
  let instanceID = clientRelationshipID++;
  return function(node) {
    if (!node.attributes) { return; }
    for (let i = 0; i < node.attributes.length; i++) {
      node.attributes[i].value = node.attributes[i].value.replace(new RegExp(slug, 'g'), instanceID)
    }
  }
}

function addRelationship(element) {
  const slug = element.dataset.slug;
  const insertBefore = document.getElementById("before-" + slug);
  const template = document.getElementById("template-" + slug);
  const placeholder = document.getElementById("placeholder-" + slug);
  const clone = document.importNode(template.content, true);
  walk(clone, updateAttributes(slug));

  // If there is a limit to how many can be added.
  if (element.dataset.limit) {
    const oldLimit = parseInt(element.dataset.limit, 10);
    const newLimit = oldLimit - 1;

    if (newLimit <= 0) {
      placeholder.parentNode.removeChild(placeholder);
    } else {
      element.dataset.limit = newLimit;
    }
  }

  insertBefore.parentNode.insertBefore(clone, insertBefore);
}

function removeRelationship(element) {
  const parent = element.parentNode;
  const field = parent.querySelector('.destroy');
  parent.style.display = "none";
  field.value = "true";
}

document.addEventListener('click', function(event) {
  if (event.target.nodeName.toLowerCase() === "button") {
    if (event.target.classList.contains('add-relationship')) {
      addRelationship(event.target);
    } else if (event.target.classList.contains('remove-relationship')) {
      removeRelationship(event.target);
    }
  }
});
